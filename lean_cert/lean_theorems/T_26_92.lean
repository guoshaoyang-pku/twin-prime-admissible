import Sound
import lean_certs.cert_26_92

open CertVerify

theorem H26_gt_92 : ¬ ∃ t : List Nat, admissible 26 t = true ∧ diameter t ≤ 92 := by
  exact certValidRoot_sound (k := 26) (d := 92) (c := cert_26_92) (by native_decide)
