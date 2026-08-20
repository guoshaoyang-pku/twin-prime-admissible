import Sound
import lean_certs.cert_22_88

open CertVerify

theorem H22_gt_88 : ¬ ∃ t : List Nat, admissible 22 t = true ∧ diameter t ≤ 88 := by
  exact certValidRoot_sound (k := 22) (d := 88) (c := cert_22_88) (by native_decide)
