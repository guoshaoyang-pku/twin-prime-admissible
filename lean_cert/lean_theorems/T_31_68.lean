import Sound
import lean_certs.cert_31_68

open CertVerify

theorem H31_gt_68 : ¬ ∃ t : List Nat, admissible 31 t = true ∧ diameter t ≤ 68 := by
  exact certValidRoot_sound (k := 31) (d := 68) (c := cert_31_68) (by native_decide)
