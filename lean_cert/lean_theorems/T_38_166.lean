import Sound
import lean_certs.cert_38_166

open CertVerify

theorem H38_gt_166 : ¬ ∃ t : List Nat, admissible 38 t = true ∧ diameter t ≤ 166 := by
  exact certValidRoot_sound (k := 38) (d := 166) (c := cert_38_166) (by native_decide)
