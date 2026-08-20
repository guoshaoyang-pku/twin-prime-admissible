import Sound
import lean_certs.cert_31_94

open CertVerify

theorem H31_gt_94 : ¬ ∃ t : List Nat, admissible 31 t = true ∧ diameter t ≤ 94 := by
  exact certValidRoot_sound (k := 31) (d := 94) (c := cert_31_94) (by native_decide)
