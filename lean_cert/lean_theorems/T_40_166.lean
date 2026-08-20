import Sound
import lean_certs.cert_40_166

open CertVerify

theorem H40_gt_166 : ¬ ∃ t : List Nat, admissible 40 t = true ∧ diameter t ≤ 166 := by
  exact certValidRoot_sound (k := 40) (d := 166) (c := cert_40_166) (by native_decide)
