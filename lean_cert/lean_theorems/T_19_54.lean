import Sound
import lean_certs.cert_19_54

open CertVerify

theorem H19_gt_54 : ¬ ∃ t : List Nat, admissible 19 t = true ∧ diameter t ≤ 54 := by
  exact certValidRoot_sound (k := 19) (d := 54) (c := cert_19_54) (by native_decide)
