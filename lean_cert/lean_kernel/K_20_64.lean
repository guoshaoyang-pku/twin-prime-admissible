import Sound
import lean_certs.cert_20_64

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H20_gt_64_kernel : ¬ ∃ t : List Nat, admissible 20 t = true ∧ diameter t ≤ 64 := by
  exact certValidRoot_sound (k := 20) (d := 64) (c := cert_20_64) (by decide)
