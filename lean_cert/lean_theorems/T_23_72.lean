import Sound
import lean_certs.cert_23_72

open CertVerify

theorem H23_gt_72 : ¬ ∃ t : List Nat, admissible 23 t = true ∧ diameter t ≤ 72 := by
  exact certValidRoot_sound (k := 23) (d := 72) (c := cert_23_72) (by native_decide)
