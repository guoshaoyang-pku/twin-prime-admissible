import Sound
import lean_certs.cert_48_166

open CertVerify

theorem H48_gt_166 : ¬ ∃ t : List Nat, admissible 48 t = true ∧ diameter t ≤ 166 := by
  exact certValidRoot_sound (k := 48) (d := 166) (c := cert_48_166) (by native_decide)
