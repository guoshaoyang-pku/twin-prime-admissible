import Sound
import lean_certs.cert_26_88

open CertVerify

theorem H26_gt_88 : ¬ ∃ t : List Nat, admissible 26 t = true ∧ diameter t ≤ 88 := by
  exact certValidRoot_sound (k := 26) (d := 88) (c := cert_26_88) (by native_decide)
