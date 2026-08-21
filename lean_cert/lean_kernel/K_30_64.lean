import Sound
import lean_certs.cert_30_64

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H30_gt_64_kernel : ¬ ∃ t : List Nat, admissible 30 t = true ∧ diameter t ≤ 64 := by
  exact certValidRoot_sound (k := 30) (d := 64) (c := cert_30_64) (by decide)
