import Sound
import lean_certs.cert_14_26

open CertVerify

theorem H14_gt_26 : ¬ ∃ t : List Nat, admissible 14 t = true ∧ diameter t ≤ 26 := by
  exact certValidRoot_sound (k := 14) (d := 26) (c := cert_14_26) (by native_decide)
