import Sound
import lean_certs.cert_38_94

open CertVerify

theorem H38_gt_94 : ¬ ∃ t : List Nat, admissible 38 t = true ∧ diameter t ≤ 94 := by
  exact certValidRoot_sound (k := 38) (d := 94) (c := cert_38_94) (by native_decide)
