import Sound
import lean_certs.cert_38_140

open CertVerify

theorem H38_gt_140 : ¬ ∃ t : List Nat, admissible 38 t = true ∧ diameter t ≤ 140 := by
  exact certValidRoot_sound (k := 38) (d := 140) (c := cert_38_140) (by native_decide)
