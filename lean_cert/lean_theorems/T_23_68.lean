import Sound
import lean_certs.cert_23_68

open CertVerify

theorem H23_gt_68 : ¬ ∃ t : List Nat, admissible 23 t = true ∧ diameter t ≤ 68 := by
  exact certValidRoot_sound (k := 23) (d := 68) (c := cert_23_68) (by native_decide)
