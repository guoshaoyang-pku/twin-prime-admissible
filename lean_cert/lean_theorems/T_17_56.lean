import Sound
import lean_certs.cert_17_56

open CertVerify

theorem H17_gt_56 : ¬ ∃ t : List Nat, admissible 17 t = true ∧ diameter t ≤ 56 := by
  exact certValidRoot_sound (k := 17) (d := 56) (c := cert_17_56) (by native_decide)
