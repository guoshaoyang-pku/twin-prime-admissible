import Sound
import lean_certs.cert_38_132

open CertVerify

theorem H38_gt_132 : ¬ ∃ t : List Nat, admissible 38 t = true ∧ diameter t ≤ 132 := by
  exact certValidRoot_sound (k := 38) (d := 132) (c := cert_38_132) (by native_decide)
