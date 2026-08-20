import Sound
import lean_certs.cert_29_110

open CertVerify

theorem H29_gt_110 : ¬ ∃ t : List Nat, admissible 29 t = true ∧ diameter t ≤ 110 := by
  exact certValidRoot_sound (k := 29) (d := 110) (c := cert_29_110) (by native_decide)
