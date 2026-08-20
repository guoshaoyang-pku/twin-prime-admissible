import Sound
import lean_certs.cert_37_110

open CertVerify

theorem H37_gt_110 : ¬ ∃ t : List Nat, admissible 37 t = true ∧ diameter t ≤ 110 := by
  exact certValidRoot_sound (k := 37) (d := 110) (c := cert_37_110) (by native_decide)
