import Sound
import lean_certs.cert_31_110

open CertVerify

theorem H31_gt_110 : ¬ ∃ t : List Nat, admissible 31 t = true ∧ diameter t ≤ 110 := by
  exact certValidRoot_sound (k := 31) (d := 110) (c := cert_31_110) (by native_decide)
