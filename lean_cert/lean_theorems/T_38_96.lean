import Sound
import lean_certs.cert_38_96

open CertVerify

theorem H38_gt_96 : ¬ ∃ t : List Nat, admissible 38 t = true ∧ diameter t ≤ 96 := by
  exact certValidRoot_sound (k := 38) (d := 96) (c := cert_38_96) (by native_decide)
