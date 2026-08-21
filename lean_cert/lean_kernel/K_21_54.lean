import Sound
import lean_certs.cert_21_54

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H21_gt_54_kernel : ¬ ∃ t : List Nat, admissible 21 t = true ∧ diameter t ≤ 54 := by
  exact certValidRoot_sound (k := 21) (d := 54) (c := cert_21_54) (by decide)
