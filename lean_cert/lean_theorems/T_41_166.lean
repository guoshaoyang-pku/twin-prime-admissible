import Sound
import lean_certs.cert_41_166

open CertVerify

theorem H41_gt_166 : ¬ ∃ t : List Nat, admissible 41 t = true ∧ diameter t ≤ 166 := by
  exact certValidRoot_sound (k := 41) (d := 166) (c := cert_41_166) (by native_decide)
