import Sound
import lean_certs.cert_41_88

open CertVerify

theorem H41_gt_88 : ¬ ∃ t : List Nat, admissible 41 t = true ∧ diameter t ≤ 88 := by
  exact certValidRoot_sound (k := 41) (d := 88) (c := cert_41_88) (by native_decide)
