import Sound
import lean_certs.cert_39_88

open CertVerify

theorem H39_gt_88 : ¬ ∃ t : List Nat, admissible 39 t = true ∧ diameter t ≤ 88 := by
  exact certValidRoot_sound (k := 39) (d := 88) (c := cert_39_88) (by native_decide)
