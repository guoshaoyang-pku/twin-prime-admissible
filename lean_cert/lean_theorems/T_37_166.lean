import Sound
import lean_certs.cert_37_166

open CertVerify

theorem H37_gt_166 : ¬ ∃ t : List Nat, admissible 37 t = true ∧ diameter t ≤ 166 := by
  exact certValidRoot_sound (k := 37) (d := 166) (c := cert_37_166) (by native_decide)
