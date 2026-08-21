import Sound
import lean_certs.cert_14_30

open CertVerify

theorem H14_gt_30 : ¬ ∃ t : List Nat, admissible 14 t = true ∧ diameter t ≤ 30 := by
  exact certValidRoot_sound (k := 14) (d := 30) (c := cert_14_30) (by native_decide)
