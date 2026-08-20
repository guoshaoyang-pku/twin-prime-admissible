import Sound
import lean_certs.cert_38_88

open CertVerify

theorem H38_gt_88 : ¬ ∃ t : List Nat, admissible 38 t = true ∧ diameter t ≤ 88 := by
  exact certValidRoot_sound (k := 38) (d := 88) (c := cert_38_88) (by native_decide)
