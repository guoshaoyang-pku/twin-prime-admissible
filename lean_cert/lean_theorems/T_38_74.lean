import Sound
import lean_certs.cert_38_74

open CertVerify

theorem H38_gt_74 : ¬ ∃ t : List Nat, admissible 38 t = true ∧ diameter t ≤ 74 := by
  exact certValidRoot_sound (k := 38) (d := 74) (c := cert_38_74) (by native_decide)
