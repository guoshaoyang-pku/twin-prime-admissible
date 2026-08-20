import Sound
import lean_certs.cert_23_58

open CertVerify

theorem H23_gt_58 : ¬ ∃ t : List Nat, admissible 23 t = true ∧ diameter t ≤ 58 := by
  exact certValidRoot_sound (k := 23) (d := 58) (c := cert_23_58) (by native_decide)
