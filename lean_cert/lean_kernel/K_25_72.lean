import Sound
import lean_certs.cert_25_72

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H25_gt_72_kernel : ¬ ∃ t : List Nat, admissible 25 t = true ∧ diameter t ≤ 72 := by
  exact certValidRoot_sound (k := 25) (d := 72) (c := cert_25_72) (by decide)
