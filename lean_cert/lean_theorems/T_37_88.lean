import Sound
import lean_certs.cert_37_88

open CertVerify

theorem H37_gt_88 : ¬ ∃ t : List Nat, admissible 37 t = true ∧ diameter t ≤ 88 := by
  exact certValidRoot_sound (k := 37) (d := 88) (c := cert_37_88) (by native_decide)
