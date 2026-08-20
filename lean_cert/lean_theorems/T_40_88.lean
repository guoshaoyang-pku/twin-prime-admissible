import Sound
import lean_certs.cert_40_88

open CertVerify

theorem H40_gt_88 : ¬ ∃ t : List Nat, admissible 40 t = true ∧ diameter t ≤ 88 := by
  exact certValidRoot_sound (k := 40) (d := 88) (c := cert_40_88) (by native_decide)
