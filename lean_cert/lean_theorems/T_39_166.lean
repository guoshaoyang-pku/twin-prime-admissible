import Sound
import lean_certs.cert_39_166

open CertVerify

theorem H39_gt_166 : ¬ ∃ t : List Nat, admissible 39 t = true ∧ diameter t ≤ 166 := by
  exact certValidRoot_sound (k := 39) (d := 166) (c := cert_39_166) (by native_decide)
