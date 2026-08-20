import Sound
import lean_certs.cert_26_58

open CertVerify

theorem H26_gt_58 : ¬ ∃ t : List Nat, admissible 26 t = true ∧ diameter t ≤ 58 := by
  exact certValidRoot_sound (k := 26) (d := 58) (c := cert_26_58) (by native_decide)
