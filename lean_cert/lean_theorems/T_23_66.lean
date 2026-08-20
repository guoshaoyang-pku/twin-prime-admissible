import Sound
import lean_certs.cert_23_66

open CertVerify

theorem H23_gt_66 : ¬ ∃ t : List Nat, admissible 23 t = true ∧ diameter t ≤ 66 := by
  exact certValidRoot_sound (k := 23) (d := 66) (c := cert_23_66) (by native_decide)
