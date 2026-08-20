import Sound
import lean_certs.cert_25_88

open CertVerify

theorem H25_gt_88 : ¬ ∃ t : List Nat, admissible 25 t = true ∧ diameter t ≤ 88 := by
  exact certValidRoot_sound (k := 25) (d := 88) (c := cert_25_88) (by native_decide)
