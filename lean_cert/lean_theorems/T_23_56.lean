import Sound
import lean_certs.cert_23_56

open CertVerify

theorem H23_gt_56 : ¬ ∃ t : List Nat, admissible 23 t = true ∧ diameter t ≤ 56 := by
  exact certValidRoot_sound (k := 23) (d := 56) (c := cert_23_56) (by native_decide)
