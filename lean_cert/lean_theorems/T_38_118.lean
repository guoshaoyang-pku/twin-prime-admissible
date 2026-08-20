import Sound
import lean_certs.cert_38_118

open CertVerify

theorem H38_gt_118 : ¬ ∃ t : List Nat, admissible 38 t = true ∧ diameter t ≤ 118 := by
  exact certValidRoot_sound (k := 38) (d := 118) (c := cert_38_118) (by native_decide)
