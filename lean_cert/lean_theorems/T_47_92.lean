import Sound
import lean_certs.cert_47_92

open CertVerify

theorem H47_gt_92 : ¬ ∃ t : List Nat, admissible 47 t = true ∧ diameter t ≤ 92 := by
  exact certValidRoot_sound (k := 47) (d := 92) (c := cert_47_92) (by native_decide)
