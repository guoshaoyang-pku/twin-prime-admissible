import Sound
import lean_certs.cert_21_72

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H21_gt_72_kernel : ¬ ∃ t : List Nat, admissible 21 t = true ∧ diameter t ≤ 72 := by
  exact certValidRoot_sound (k := 21) (d := 72) (c := cert_21_72) (by decide)
