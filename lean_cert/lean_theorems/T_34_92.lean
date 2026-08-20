import Sound
import lean_certs.cert_34_92

open CertVerify

theorem H34_gt_92 : ¬ ∃ t : List Nat, admissible 34 t = true ∧ diameter t ≤ 92 := by
  exact certValidRoot_sound (k := 34) (d := 92) (c := cert_34_92) (by native_decide)
