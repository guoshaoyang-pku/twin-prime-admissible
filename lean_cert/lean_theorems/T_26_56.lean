import Sound
import lean_certs.cert_26_56

open CertVerify

theorem H26_gt_56 : ¬ ∃ t : List Nat, admissible 26 t = true ∧ diameter t ≤ 56 := by
  exact certValidRoot_sound (k := 26) (d := 56) (c := cert_26_56) (by native_decide)
