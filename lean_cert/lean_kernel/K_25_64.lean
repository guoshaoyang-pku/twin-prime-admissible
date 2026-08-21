import Sound
import lean_certs.cert_25_64

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H25_gt_64_kernel : ¬ ∃ t : List Nat, admissible 25 t = true ∧ diameter t ≤ 64 := by
  exact certValidRoot_sound (k := 25) (d := 64) (c := cert_25_64) (by decide)
