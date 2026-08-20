import Sound
import lean_certs.cert_38_98

open CertVerify

theorem H38_gt_98 : ¬ ∃ t : List Nat, admissible 38 t = true ∧ diameter t ≤ 98 := by
  exact certValidRoot_sound (k := 38) (d := 98) (c := cert_38_98) (by native_decide)
