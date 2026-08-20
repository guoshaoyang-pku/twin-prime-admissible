import Sound
import lean_certs.cert_38_142

open CertVerify

theorem H38_gt_142 : ¬ ∃ t : List Nat, admissible 38 t = true ∧ diameter t ≤ 142 := by
  exact certValidRoot_sound (k := 38) (d := 142) (c := cert_38_142) (by native_decide)
