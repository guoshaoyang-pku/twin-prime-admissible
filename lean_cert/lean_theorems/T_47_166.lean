import Sound
import lean_certs.cert_47_166

open CertVerify

theorem H47_gt_166 : ¬ ∃ t : List Nat, admissible 47 t = true ∧ diameter t ≤ 166 := by
  exact certValidRoot_sound (k := 47) (d := 166) (c := cert_47_166) (by native_decide)
