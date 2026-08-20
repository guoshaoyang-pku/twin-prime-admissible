import Sound
import lean_certs.cert_38_162

open CertVerify

theorem H38_gt_162 : ¬ ∃ t : List Nat, admissible 38 t = true ∧ diameter t ≤ 162 := by
  exact certValidRoot_sound (k := 38) (d := 162) (c := cert_38_162) (by native_decide)
