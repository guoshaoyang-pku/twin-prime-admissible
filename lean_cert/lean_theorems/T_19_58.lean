import Sound
import lean_certs.cert_19_58

open CertVerify

theorem H19_gt_58 : ¬ ∃ t : List Nat, admissible 19 t = true ∧ diameter t ≤ 58 := by
  exact certValidRoot_sound (k := 19) (d := 58) (c := cert_19_58) (by native_decide)
