import Sound
import lean_certs.cert_23_80

open CertVerify

theorem H23_gt_80 : ¬ ∃ t : List Nat, admissible 23 t = true ∧ diameter t ≤ 80 := by
  exact certValidRoot_sound (k := 23) (d := 80) (c := cert_23_80) (by native_decide)
