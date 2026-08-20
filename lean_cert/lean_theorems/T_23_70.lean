import Sound
import lean_certs.cert_23_70

open CertVerify

theorem H23_gt_70 : ¬ ∃ t : List Nat, admissible 23 t = true ∧ diameter t ≤ 70 := by
  exact certValidRoot_sound (k := 23) (d := 70) (c := cert_23_70) (by native_decide)
