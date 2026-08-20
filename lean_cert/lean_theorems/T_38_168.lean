import Sound
import lean_certs.cert_38_168

open CertVerify

theorem H38_gt_168 : ¬ ∃ t : List Nat, admissible 38 t = true ∧ diameter t ≤ 168 := by
  exact certValidRoot_sound (k := 38) (d := 168) (c := cert_38_168) (by native_decide)
