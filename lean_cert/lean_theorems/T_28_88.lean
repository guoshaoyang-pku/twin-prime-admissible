import Sound
import lean_certs.cert_28_88

open CertVerify

theorem H28_gt_88 : ¬ ∃ t : List Nat, admissible 28 t = true ∧ diameter t ≤ 88 := by
  exact certValidRoot_sound (k := 28) (d := 88) (c := cert_28_88) (by native_decide)
