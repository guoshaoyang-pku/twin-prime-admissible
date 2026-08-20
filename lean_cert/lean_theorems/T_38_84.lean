import Sound
import lean_certs.cert_38_84

open CertVerify

theorem H38_gt_84 : ¬ ∃ t : List Nat, admissible 38 t = true ∧ diameter t ≤ 84 := by
  exact certValidRoot_sound (k := 38) (d := 84) (c := cert_38_84) (by native_decide)
