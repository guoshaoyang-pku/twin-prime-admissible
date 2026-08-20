import Sound
import lean_certs.cert_22_56

open CertVerify

theorem H22_gt_56 : ¬ ∃ t : List Nat, admissible 22 t = true ∧ diameter t ≤ 56 := by
  exact certValidRoot_sound (k := 22) (d := 56) (c := cert_22_56) (by native_decide)
